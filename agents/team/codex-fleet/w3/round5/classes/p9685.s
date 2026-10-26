# n=5 model=out iset=I1 prefix14_class=9685
cmp P0, P3
cmovle S2, P3
cmovg S2, P0
cmovle P3, P0
cmp P1, P2
cmovle P0, P2
cmovle P2, P1
cmovl P1, P0
mov S1, S2
cmp S1, P1
cmovge S2, P1
cmovge P1, S1
cmovg S1, S2
cmp P2, P3
