# n=5 model=out iset=I1 prefix14_class=921
mov S0, P3
cmp P2, P3
mov S1, P0
cmovg S0, P2
mov S2, S0
cmovl P3, P2
cmp S1, P1
cmovg P0, P1
cmovge P1, S1
mov P2, P0
cmp P1, S0
cmovg S2, P1
cmovge P1, S0
cmp P3, P2
