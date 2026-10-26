# n=5 model=out iset=I1 prefix14_class=9498
mov S0, P0
cmp P2, S0
cmovg S0, P2
cmovge P2, P0
cmp P3, P1
cmovg S1, P3
cmovle S1, P1
cmovle P1, P3
cmp P1, P2
cmovle P3, P2
cmovl P2, P1
mov S2, S0
cmovle P1, P3
cmp S1, S0
