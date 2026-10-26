# n=5 model=out iset=I1 prefix14_class=10747
mov S0, P0
cmp P3, P0
cmovg S0, P3
cmovl P0, P3
cmovle P3, S0
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovle P2, S1
cmp S0, P1
cmovl P3, P1
cmovl P1, S0
cmp P2, P0
cmovge P3, P0
