# n=5 model=out iset=I1 prefix14_class=831
cmp P1, P3
cmovge S2, P1
cmovge P1, P3
cmovle S2, P3
mov P3, P0
cmp P2, P0
cmovl P0, P2
cmovg P3, P2
mov S0, S2
cmp P3, S0
cmovl S0, P3
cmovge S2, P3
mov P2, P0
cmp P2, P1
