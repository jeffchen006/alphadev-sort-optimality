# n=5 model=out iset=I1 prefix14_class=7398
mov S0, P1
cmp S0, P2
cmovle P1, P2
cmovl P2, S0
cmp P3, P0
cmovg S2, P3
mov S1, P2
cmovge P3, P0
cmovg P0, S2
cmp P3, S1
cmovge P2, P3
cmovg P3, S1
cmp P1, P0
cmovle S2, P0
