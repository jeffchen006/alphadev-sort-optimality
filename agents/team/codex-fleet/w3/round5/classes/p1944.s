# n=5 model=out iset=I1 prefix14_class=1944
cmp P0, P2
cmovle S1, P0
cmovge S1, P2
cmovl P0, P2
mov S2, P1
cmp P3, P1
cmovle S2, P3
cmovg P1, P3
mov P2, P1
cmp P0, P2
cmovge P1, P0
cmovle P2, P0
mov P3, P2
cmp S2, S1
