# n=5 model=out iset=I1 prefix14_class=9400
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
cmp P0, S0
mov P2, S2
