# n=5 model=out iset=I1 prefix14_class=3097
mov S1, P3
cmp S1, P1
cmovg P3, P1
mov S2, P0
cmovl S1, P1
cmp P2, S2
cmovle S2, P2
cmovl P2, P0
cmp S2, P3
mov S0, P3
cmovl S0, S2
mov P0, S1
cmovle S2, P3
mov P1, S2
