# n=5 model=out iset=I1 prefix14_class=1747
mov S2, P2
cmp P2, P1
cmovg S2, P1
cmovl P2, P1
cmovle P1, S2
mov S0, P3
cmp P3, P0
cmovle P3, P0
cmovg S0, P0
mov S1, P3
cmp S0, P1
cmovl S2, S0
cmovle S0, P1
cmovge P1, S0
