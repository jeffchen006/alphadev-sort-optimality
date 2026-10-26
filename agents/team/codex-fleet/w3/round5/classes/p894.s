# n=5 model=out iset=I1 prefix14_class=894
cmp P0, P2
mov S0, P2
cmovl P2, P0
cmovle P0, S0
cmovg S0, P0
cmp P3, P1
cmovle S1, P3
cmovg S1, P1
cmovge P1, P3
cmp P1, P0
cmovle P0, P1
cmovge S0, P1
cmp S1, P2
cmovle P3, S1
