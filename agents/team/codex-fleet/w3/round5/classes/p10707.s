# n=5 model=out iset=I1 prefix14_class=10707
mov S2, P2
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovle P0, S1
cmp P1, P2
cmovge P2, P1
cmovle S2, P1
mov P1, P2
cmp P1, P3
cmovl P2, P3
cmovle P3, P1
cmp P0, S2
mov P1, S2
