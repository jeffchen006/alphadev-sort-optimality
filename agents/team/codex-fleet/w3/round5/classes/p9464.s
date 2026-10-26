# n=5 model=out iset=I1 prefix14_class=9464
mov S1, P3
cmp P1, P2
cmovle S0, P2
cmovg S0, P1
cmovl P2, P1
cmp P3, P0
cmovg P3, P0
cmovge P0, S1
cmp P2, P3
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
cmp S0, P0
cmovle P3, S0
