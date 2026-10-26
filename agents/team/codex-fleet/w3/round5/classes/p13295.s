# n=5 model=out iset=I1 prefix14_class=13295
cmp P3, P0
mov S2, P3
cmovle P3, P0
cmovl P0, S2
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
mov S1, P3
cmovle P1, S2
mov S0, P0
cmp P0, P2
cmovg S0, P2
cmovge P2, P0
cmp P3, P1
