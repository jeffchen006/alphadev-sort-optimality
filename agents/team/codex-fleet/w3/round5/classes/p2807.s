# n=5 model=out iset=I1 prefix14_class=2807
mov S1, P1
cmp S1, P0
cmovge S1, P0
mov S2, P3
cmovge P0, P1
cmp P2, S2
cmovle S2, P2
cmovl P2, P3
cmp P2, P0
cmovg P3, P0
cmovg P0, P2
cmovg P2, P3
cmp S1, S2
cmovle P3, S1
