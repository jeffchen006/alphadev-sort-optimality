# n=5 model=out iset=I1 prefix14_class=13383
mov S2, P3
cmp S2, P2
cmovg P3, P2
mov S1, P0
cmovge P2, S2
cmp P1, S1
cmovle S1, P1
cmovg P0, P1
cmp S1, P3
cmovle P1, P3
cmovle P3, S1
cmovl S1, P1
cmp P0, P2
cmovl P1, P2
