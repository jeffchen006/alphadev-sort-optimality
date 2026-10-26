# n=5 model=out iset=I1 prefix14_class=3914
mov S2, P1
cmp P1, P0
cmovge P1, P0
cmovg P0, S2
cmp P2, P3
mov S0, P2
cmovle P2, P3
cmovle P3, S0
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovge S1, P1
cmp P0, P2
cmovge P3, P2
