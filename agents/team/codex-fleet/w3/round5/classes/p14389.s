# n=5 model=out iset=I1 prefix14_class=14389
mov S0, P2
cmp P1, P3
cmovle S1, P3
cmovg S1, P1
cmovle P3, P1
cmp S0, P0
cmovg S0, P0
cmovl P2, P0
cmp P3, S0
cmovg P0, P3
cmovge P3, S0
cmovg S0, P0
cmp S1, P2
cmovle P1, S1
