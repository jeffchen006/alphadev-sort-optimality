# n=5 model=out iset=I1 prefix14_class=3059
mov S1, P3
cmp P0, S1
cmovge S1, P0
cmovg P0, P3
mov P3, P1
cmp P2, P3
cmovle P1, P2
cmovl P2, P3
cmp P1, P0
cmovg P3, P1
cmovg P1, P0
cmovg P0, P3
cmp S1, P2
cmovle S0, P2
