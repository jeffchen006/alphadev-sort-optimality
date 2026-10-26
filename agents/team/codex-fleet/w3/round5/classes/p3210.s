# n=5 model=out iset=I1 prefix14_class=3210
cmp P1, P3
mov S1, P3
cmovl P3, P1
cmovg S1, P1
mov S0, P2
cmp P0, P2
cmovge P2, P0
cmovge P0, S0
mov S0, P0
cmp P3, P0
cmovg S0, P3
cmovge P3, P0
cmp S1, P2
cmovge P1, S1
