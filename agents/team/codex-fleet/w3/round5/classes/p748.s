# n=5 model=out iset=I1 prefix14_class=748
cmp P2, P3
cmovge S2, P3
cmovl S2, P2
cmovle P2, P3
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
cmovge S0, P1
mov P3, P0
cmp P0, P2
cmovl P0, P2
cmovle P2, P3
cmp S2, S0
cmovg P3, S2
