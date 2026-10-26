# n=5 model=out iset=I1 prefix14_class=5177
mov S2, P0
cmp S2, P1
cmovle P0, P1
cmovle P1, S2
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
cmovl P3, S2
cmp P2, P1
mov S2, P2
cmovg P2, P1
mov P2, P3
cmovge P1, S2
cmp P0, P3
