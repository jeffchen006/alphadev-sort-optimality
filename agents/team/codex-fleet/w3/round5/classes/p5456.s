# n=5 model=out iset=I1 prefix14_class=5456
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmovg S1, P0
mov P0, S1
cmp P3, P2
cmovge S0, P2
mov S2, P1
cmovge P2, P3
cmovge P3, S0
cmp P3, S1
cmovl P0, P3
cmovl P3, S1
cmp P1, P2
