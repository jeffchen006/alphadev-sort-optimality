# n=5 model=out iset=I1 prefix14_class=13239
cmp P2, P3
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
cmp P1, P0
cmovge S1, P0
cmovle S1, P1
cmovle P1, P0
cmp S1, P3
cmovle P0, P3
cmovle P3, S1
cmovl S1, P0
mov P3, P2
cmp P3, P1
