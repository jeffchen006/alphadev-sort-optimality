# n=5 model=out iset=I1 prefix14_class=4943
cmp P3, P2
mov S1, P0
mov S2, P2
cmovg S2, P3
cmovg P3, P2
cmp S1, P1
cmovle P0, P1
cmovl P1, S1
cmp P3, P1
cmovge P2, P3
cmovge P3, P1
cmovge P1, P2
cmp S2, P0
cmovle S0, P0
