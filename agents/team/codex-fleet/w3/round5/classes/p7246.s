# n=5 model=out iset=I1 prefix14_class=7246
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovge S1, P2
cmp P1, P3
cmovle P2, P3
cmovl P3, P1
cmovle P1, P2
mov S0, P3
cmp P3, P0
cmovg P3, P0
cmovle S0, P0
cmp S1, P1
cmovge P3, P1
