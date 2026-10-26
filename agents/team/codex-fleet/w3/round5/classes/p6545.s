# n=5 model=out iset=I1 prefix14_class=6545
cmp P1, P3
cmovle S2, P3
cmovg S2, P1
mov S1, P2
cmovl P3, P1
cmp P2, P0
cmovle S1, P0
mov S0, S1
cmovl P0, P2
cmp S0, S2
cmovle S1, S2
cmovg S0, S2
mov S1, P0
cmovle S2, S0
