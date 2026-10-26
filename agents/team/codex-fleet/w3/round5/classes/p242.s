# n=5 model=out iset=I1 prefix14_class=242
cmp P0, P2
mov S1, P3
cmovle S2, P2
cmovge S2, P0
cmovle P2, P0
cmovl P0, S2
cmp S1, P1
cmovg P3, P1
cmovge P1, S1
cmp P3, P2
cmovle S1, P2
cmovle P2, P3
cmovl P3, S1
cmp S2, P1
