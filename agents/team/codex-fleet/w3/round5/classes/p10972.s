# n=5 model=out iset=I1 prefix14_class=10972
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
mov S2, P3
cmovge P0, S1
cmp P0, S2
cmovg S2, P0
cmovl P3, P0
cmp P1, P2
cmovle P0, P2
