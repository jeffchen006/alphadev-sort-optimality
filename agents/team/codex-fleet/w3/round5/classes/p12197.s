# n=5 model=out iset=I1 prefix14_class=12197
mov S2, P2
cmp P0, P2
cmovle P2, P0
cmovg S2, P0
cmp P1, P3
cmovle P0, P3
cmovl P3, P1
cmovle P1, P0
mov S0, P2
cmp S0, P3
cmovg S0, P3
cmovge P3, P2
cmp S2, P1
cmovle S1, P1
