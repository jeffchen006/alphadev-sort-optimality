# n=5 model=out iset=I1 prefix14_class=9907
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
mov S2, P1
cmovg P0, S1
cmp S2, P2
cmovl P1, P2
cmovle P2, S2
cmp P1, P0
cmovge S2, P0
cmovle S2, P1
cmovle P1, P0
mov P0, P2
cmp P0, P3
