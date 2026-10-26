# n=5 model=out iset=I1 prefix14_class=8986
cmp P3, P2
cmovg S0, P2
cmovg P2, P3
cmovg P3, S0
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovg S2, P1
mov P1, P0
cmp P2, P1
cmovl P0, P2
cmovg P1, P2
mov P2, S2
cmp S2, P3
