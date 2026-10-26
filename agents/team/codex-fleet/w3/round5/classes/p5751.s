# n=5 model=out iset=I1 prefix14_class=5751
cmp P2, P3
cmovg S1, P3
cmovle S1, P2
cmovl P2, P3
mov P3, P1
cmp P3, P0
cmovge P3, P0
cmovge P0, P1
mov S2, P2
cmp S1, P3
cmovle S0, P3
cmovl P3, S1
cmovle S1, S0
cmp P2, P0
