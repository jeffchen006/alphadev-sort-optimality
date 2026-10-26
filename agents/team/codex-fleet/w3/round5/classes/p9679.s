# n=5 model=out iset=I1 prefix14_class=9679
cmp P3, P1
cmovle S0, P1
cmovg S0, P3
cmovg P3, P1
mov S1, P2
cmovge P1, S0
cmp P0, P2
cmovle P2, P0
cmovle P0, S1
cmp S0, P0
cmovl P1, P0
cmovl P0, S0
cmp P3, P2
cmovge P1, P2
