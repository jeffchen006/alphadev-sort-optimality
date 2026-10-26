# n=5 model=out iset=I1 prefix14_class=9901
mov S2, P2
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovge P1, S0
cmp S2, P0
mov S1, P1
cmovle S2, P0
cmovl P0, P2
cmp S2, P1
cmovl S1, S2
cmovl S2, P1
mov S2, S1
mov P2, P3
