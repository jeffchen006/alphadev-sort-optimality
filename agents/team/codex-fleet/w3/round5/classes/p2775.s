# n=5 model=out iset=I1 prefix14_class=2775
cmp P2, P1
cmovge S2, P2
cmovle S2, P1
cmovge P2, P1
cmp P0, P3
cmovl S1, P3
cmovge S1, P0
cmovg P0, P3
cmp S2, S1
cmovle P3, S1
cmovg P3, S2
cmovge S2, S1
mov P3, P2
cmp P0, P3
