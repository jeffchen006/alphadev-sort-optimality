# n=5 model=out iset=I1 prefix14_class=13774
cmp P0, P1
mov S0, P1
cmovle P1, P0
mov S1, P2
cmovle P0, S0
cmp S1, P3
cmovg S1, P3
cmovge P3, P2
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
mov P3, P1
cmovle P0, S0
cmp S1, P3
