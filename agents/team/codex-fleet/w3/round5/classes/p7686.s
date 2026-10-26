# n=5 model=out iset=I1 prefix14_class=7686
cmp P0, P1
cmovge S2, P1
cmovge P1, P0
cmovl S2, P0
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
mov P0, S2
cmp S2, P2
cmovle P0, P2
cmovl P2, S2
cmp P3, P1
cmovl P2, P1
