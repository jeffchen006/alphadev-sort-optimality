# n=5 model=out iset=I1 prefix14_class=3586
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovl P2, S1
mov S0, P3
cmp P0, P3
cmovg S0, P0
cmovle P3, P0
cmp P3, P2
mov P0, P2
cmovl P2, P3
mov S2, P1
cmovge P0, P3
mov P3, P0
