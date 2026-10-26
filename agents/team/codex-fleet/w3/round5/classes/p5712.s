# n=5 model=out iset=I1 prefix14_class=5712
cmp P1, P2
cmovle S0, P2
cmovge S0, P1
cmovl P2, P1
mov P1, P0
cmp P3, P1
cmovge P0, P3
cmovle P1, P3
cmp P2, P1
cmovg S1, P1
cmovg P1, P2
cmovg P2, S1
cmp S0, P0
cmovle S1, P0
