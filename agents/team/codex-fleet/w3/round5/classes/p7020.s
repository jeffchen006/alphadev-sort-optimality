# n=5 model=out iset=I1 prefix14_class=7020
cmp P1, P0
cmovg S2, P1
cmovle S2, P0
cmovg P1, P0
mov S0, P3
cmp S0, P2
cmovg P3, P2
cmovl S0, P2
cmp P1, P3
cmovge P0, P1
cmovg P1, P3
cmovg P3, P0
mov P2, S0
mov P1, P3
