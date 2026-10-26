# n=5 model=out iset=I1 prefix14_class=13354
cmp P0, P1
mov S2, P2
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
mov S1, P1
cmp P3, S2
cmovl P2, P3
cmovge S2, P3
cmp P2, S1
cmovle P1, P2
cmovg S1, P2
mov P1, S1
cmp S2, P0
