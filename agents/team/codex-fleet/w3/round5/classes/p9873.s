# n=5 model=out iset=I1 prefix14_class=9873
cmp P2, P3
mov S0, P3
cmovg S0, P2
mov S2, P1
cmovl P3, P2
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmp S0, S2
cmovl P1, S2
cmovge P1, S0
cmovle S2, S0
cmp P3, P0
mov P1, S2
