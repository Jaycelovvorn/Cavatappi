from flask import Flask, render_template, request, jsonify
from pathlib import Path
# For local testing
app = Flask(__name__)

BASE = Path(__file__).resolve().parent


def add_sub_16(a_int: int, b_int: int, sub: int):
    mask = 0xFFFF
    a = a_int & mask
    b = b_int & mask
    bx = b ^ (mask if sub else 0)
    result = 0
    carry = sub
    for i in range(16):
        ai = (a >> i) & 1
        bi = (bx >> i) & 1
        s = ai ^ bi ^ carry
        result |= (s << i)
        cout = (ai & bi) | (bi & carry) | (ai & carry)
        carry = cout
    carry_out = carry
    
    carry = sub
    for i in range(15):
        ai = (a >> i) & 1
        bi = (bx >> i) & 1
        cout = (ai & bi) | (bi & carry) | (ai & carry)
        carry = cout
    carry_into_msb = carry
    overflow = (carry_into_msb ^ carry_out) & 1
    zero = 1 if (result & mask) == 0 else 0
    signed_result = result if result < 0x8000 else result - 0x10000
    return {
        "A": a,
        "B": b,
        "SUB": sub,
        "Result": result & mask,
        "Result_signed": signed_result,
        "CarryOut": carry_out,
        "Overflow": overflow,
        "Zero": zero,
        "hex": f"0x{(result & mask):04X}",
    }


def mul_16(a_int: int, b_int: int):
    mask = 0xFFFF
    a = a_int & mask
    b = b_int & mask
    product = 0
    for i in range(16):
        if (b >> i) & 1:
            product = (product + (a << i)) & 0xFFFFFFFF
    low = product & mask
    high = (product >> 16) & mask
    return {
        "A": a,
        "B": b,
        "Product32": product,
        "High16": high,
        "Low16": low,
        "hex": f"0x{product:08X}",
        "Overflow": 1 if high != 0 else 0,
    }


def div_16(a_int: int, b_int: int):
    mask = 0xFFFF
    a = a_int & mask
    b = b_int & mask
    if b == 0:
        return {"DivByZero": True}
    q = a // b
    r = a % b
    return {
        "A": a,
        "B": b,
        "Quotient": q & mask,
        "Remainder": r & mask,
        "Qhex": f"0x{q & mask:04X}",
        "Rhex": f"0x{r & mask:04X}",
    }


@app.route("/")
def index():
    files = {}
    for fname in ("adder_subtractor_16.vhd", "tb_adder_subtractor_16.vhd"):
        p = BASE / fname
        files[fname] = p.read_text() if p.exists() else f"{fname} not found in {BASE}"
    return render_template("index.html", files=files)


@app.route("/api/compute", methods=["POST"])
def api_compute():
    data = request.get_json(force=True)
    try:
        A = int(data.get("A", 0))
        B = int(data.get("B", 0))
        OP = data.get("OP", "ADD").upper()
        if OP == 'SUB':
            res = add_sub_16(A, B, 1)
            return jsonify(res)
        elif OP == 'ADD':
            res = add_sub_16(A, B, 0)
            return jsonify(res)
        elif OP == 'MUL':
            res = mul_16(A, B)
            return jsonify(res)
        elif OP == 'DIV':
            res = div_16(A, B)
            return jsonify(res)
        else:
            return jsonify({"error": "Unknown OP"}), 400
    except Exception:
        return jsonify({"error": "invalid input"}), 400


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

