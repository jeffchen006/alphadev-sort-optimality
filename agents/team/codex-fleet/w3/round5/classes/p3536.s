# n=5 model=out iset=I1 prefix14_class=3536
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
cmovle S2, P2
mov P2, P0
cmp P2, P3
cmovle P0, P3
cmovl P3, P2
mov S0, P3
cmp P1, P3
cmovg S0, P1
cmovl P3, P1
cmp P0, S2
cmovge P3, S2
