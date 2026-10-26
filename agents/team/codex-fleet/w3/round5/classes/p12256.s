# n=5 model=out iset=I1 prefix14_class=12256
mov S2, P3
cmp P0, S2
cmovle P3, P0
cmovle P0, S2
mov S1, P2
cmp P2, P1
cmovge P2, P1
cmovg P1, S1
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmovl P3, S1
cmp P0, P1
cmovge S1, P1
