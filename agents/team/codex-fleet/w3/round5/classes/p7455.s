# n=5 model=out iset=I1 prefix14_class=7455
cmp P1, P3
mov S1, P1
cmovle S1, P3
cmovge P1, P3
cmovle P3, P1
cmp P2, P0
cmovg S0, P2
cmovg P2, P0
cmovle S0, P0
cmp P3, P2
cmovl P3, P2
cmovg P1, P2
cmp S0, S1
cmovl P2, S0
