class VHDLLogicGates:
    def __init__(self):
        self.operations = {
            'NOT': self.not_gate,
            'AND': self.and_gate,
            'OR': self.or_gate,
            'NOR': self.nor_gate,
            'NAND': self.nand_gate,
            'XOR': self.xor_gate,
            'XNOR': self.xnor_gate,
            'IMPLY': self.imply_gate,
            'NIMPLY': self.nimply_gate
        }

    def not_gate(self, a):
        return not a

    def and_gate(self, a, b):
        return a and b

    def or_gate(self, a, b):
        return a or b

    def nor_gate(self, a, b):
        return not (a or b)

    def nand_gate(self, a, b):
        return not (a and b)

    def xor_gate(self, a, b):
        return a != b

    def xnor_gate(self, a, b):
        return a == b

    def imply_gate(self, a, b):
        return (not a) or b

    def nimply_gate(self, a, b):
        return a and (not b)

    def evaluate(self, gate_type, *inputs):
        if gate_type not in self.operations:
            raise ValueError(f"Unknown gate type: {gate_type}")
        
        if gate_type == 'NOT' and len(inputs) != 1:
            raise ValueError("NOT gate requires exactly one input")
        elif gate_type != 'NOT' and len(inputs) != 2:
            raise ValueError(f"{gate_type} gate requires exactly two inputs")

        return self.operations[gate_type](*inputs)

# Example usage:
if __name__ == "__main__":
    vhdl = VHDLLogicGates()
