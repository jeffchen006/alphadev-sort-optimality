# n=5 model=out iset=I1 prefix14_class=4393
mov S2, P0
cmp P3, S2
cmovge P0, P3
cmovge P3, S2
cmp P2, P1
mov S0, P1
cmovge S0, P2
cmovl P1, P2
mov P2, S0
cmp P0, S0
cmovg S2, P3
cmovge P2, P0
cmovge P0, S0
cmp P3, P1
