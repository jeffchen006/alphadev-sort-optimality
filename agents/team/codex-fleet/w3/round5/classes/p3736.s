# n=5 model=out iset=I1 prefix14_class=3736
cmp P2, P3
cmovle S2, P3
cmovg S2, P2
cmovl P3, P2
mov S1, P0
cmp P1, S1
cmovg P0, P1
cmovge P1, S1
cmp P1, P3
mov S0, P3
cmovge S0, P1
cmovle P3, P1
cmp S2, P0
cmovle P2, P0
