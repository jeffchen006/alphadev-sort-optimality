# n=5 model=out iset=I1 prefix14_class=9401
mov S0, P2
cmp P1, P2
cmovg S0, P1
mov S2, P3
cmovge P1, P2
cmp P0, S2
cmovle S2, P0
cmovl P0, P3
cmp P1, S2
cmovge P3, P1
cmovge P1, S2
cmovge S2, P3
mov P2, S2
cmp S0, P0
