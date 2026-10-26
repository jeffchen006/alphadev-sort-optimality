# n=5 model=out iset=I1 prefix14_class=793
mov S1, P0
cmp P0, P2
mov S0, P3
cmovg P0, P2
cmovl S1, P2
cmp P3, P1
cmovg P3, P1
cmovge P1, S0
mov S0, P1
cmp S0, S1
cmovg P1, S1
cmovg S1, S0
mov P2, P0
mov S0, P1
