# n=5 model=out iset=I1 prefix14_class=13843
mov S0, P3
mov S2, P0
cmp S2, P2
cmovge S2, P2
cmovle P0, P2
cmp P1, P3
cmovle S0, P1
cmovg P3, P1
cmp P0, P3
mov P1, S0
cmovle P2, P3
cmovle P3, P0
cmovl P0, P2
cmp S2, S0
