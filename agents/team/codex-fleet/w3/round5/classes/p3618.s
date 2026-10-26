# n=5 model=out iset=I1 prefix14_class=3618
mov S0, P2
cmp S0, P3
cmovle S0, P3
cmovle P3, P2
mov P2, P1
cmp P0, P2
cmovle P1, P0
mov S2, P1
cmovle P0, P2
cmp P3, S2
cmovl P1, P3
cmovle P3, S2
cmp S0, P0
cmovl P1, P0
