# n=5 model=out iset=I1 prefix14_class=14427
cmp P2, P1
mov S1, P3
mov S2, P2
cmovge S2, P1
cmovl P2, P1
cmp P0, P3
cmovle S1, P0
cmovge P3, P0
mov P0, S1
cmp P0, S2
cmovle S1, P3
cmovge P0, S2
cmovg S2, S1
cmp P2, P3
